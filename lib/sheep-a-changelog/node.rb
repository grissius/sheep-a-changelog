module SheepAChangelog
  class Node
    attr_accessor :lines, :nodes
    def self.parse(string)
      new(string.split("\n"))
    end

    def hashes(n = @level)
      '#' * n
    end

    # Contruct nodes for current node from all lines
    def build_nodes(lines, next_level)
      last = nil
      nodes = []
      line_buff = []
      lines.map do |line|
        match = line.match(Regexp.new('^' + hashes(next_level) + '\s+([\S\s]+)$'))
        heading = match && match.captures.first
        if heading
          @lines, nodes = last.nil? ? [line_buff, nodes] : [@lines, nodes << Node.new(line_buff, last, next_level)]
          last = heading
          line_buff = []
        else
          line_buff << line
        end
      end
      @lines, nodes = last.nil? ? [line_buff, nodes] : [@lines, nodes << Node.new(line_buff, last, next_level)]
      nodes
    end

    # Create node hierarchy from keep-a-changeloh markdown lines
    def initialize(lines, title = :empty, level = 0)
      @title = title
      @nodes = build_nodes(lines, level + 1)
      @level = level
    end

    # Format your node's title
    def format_heading
      "#{hashes} #{@title}"
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

    def build_tree
      { title: @title, lines: @lines, nodes: @nodes.map(&:build_tree) }
    end
  end
end
