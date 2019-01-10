module SheepAChangelog
  class Node
    def self.parse(string)
      new(string.split("\n"))
    end

    # Contruct nodes for current node from all lines
    def build_nodes(lines, level)
      last = :self
      nodes = []
      line_buff = []
      lines.map do |line|
        match = line.match(Regexp.new('^' + ('#' * (level + 1)) + '\s+([\S\s]+)$'))
        heading = match && match.captures.first
        if heading
          if last.is_a?(Symbol)
            @lines = line_buff.clone
          else
            nodes << Node.new(line_buff.clone, last, level + 1)
          end
          last = heading
          line_buff = []
        else
          line_buff << line
        end
      end
      if last.is_a?(Symbol)
        @lines = line_buff.clone
      else
        nodes << Node.new(line_buff.clone, last, level + 1)
      end
      nodes
    end

    # Create node hierarchy from keep-a-changeloh markdown lines
    def initialize(lines, title = :empty, level = 0)
      # @all_lines = lines
      @title = title
      @nodes = build_nodes(lines, level)
      @level = level
    end

    # Format your node's title
    def format_heading
      "#{'#' * @level} #{@title}"
    end

    # Get lines from
    # 1. your title
    # 2. your immidiate lines
    # 3. recursively from your direct nodes
    def all_lines
      res = []
      res << format_heading if @title != :empty
      res += @lines unless @lines.empty?
      res += @nodes.map(&:all_lines) unless @nodes.empty?
      res
    end

    # Print the markdown output
    def to_s
      all_lines.join("\n")
    end
  end
end
