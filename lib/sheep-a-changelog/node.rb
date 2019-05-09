module SheepAChangelog
  class Node
    attr_reader :lines
    attr_accessor :nodes, :title, :anchors
    def self.parse(string)
      new(string.split("\n"))
    end

    def hashes(n = @level)
      '#' * n
    end

    def h_regexp(level)
      Regexp.new('^' + hashes(level) + '\s+([\S\s]+)$')
    end

    # Contruct nodes for current node from all lines
    def build_nodes(lines, next_level)
      last = nil
      line_buff = []
      (lines + [:last]).each_with_object([]) do |line, nodes|
        heading = line[h_regexp(next_level), 1] if line.is_a? String
        if heading || line == :last
          if last.nil?
            @lines = line_buff
          else
            nodes << Node.new(line_buff, last, next_level)
          end
          last = heading
          line_buff = []
        else
          line_buff << line
        end
      end
    end

    def self.pick_lines(lines)
      # add matches for links
      groups_lines = lines.inject([]) do |acc, line|
        groups = line.match(/^\[(.*)\]\s*:\s*(\S+)\s*$/).to_a
        acc + [[groups, line]]
      end
      # if no matches, it is content lines
      content_lines = groups_lines
        .select { |x| x.first.empty? }.map { |_, l| l }
      # if matches, it is link
      anchors = groups_lines
        .reject { |x| x.first.empty? }
        .map { |groups, _| { v: groups[1], url: groups[2] } }
      [content_lines, anchors]
    end

    # Create node hierarchy from keep-a-changeloh markdown lines
    def initialize(lines, title, level)
      content_lines, anchors = Node.pick_lines(lines)
      @title = title
      @anchors = anchors
      @nodes = build_nodes(content_lines, level + 1)
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
      res += all_lines_wo_heading
      res
    end

    def all_lines_wo_heading
      res = []
      res += @lines
      res += @nodes.map(&:all_lines)
      res += @anchors.map { |a| "[#{a[:v]}]: #{a[:url]}" }
      res
    end

    # Print the markdown output
    def to_s
      all_lines.join("\n")
    end

    # Serialize tree to the hashes
    def build_tree
      { title: @title,
        lines: @lines,
        anchors: @anchors,
        nodes: @nodes.map(&:build_tree) }
    end
  end
end
