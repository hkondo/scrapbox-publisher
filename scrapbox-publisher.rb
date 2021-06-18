require 'sbpub'
require 'optparse'

# scrapbox-publisher

class ScrapboxPublisher

  attr_accessor :conf

  def initialize
    @opts = OptionParser.new
    @opts.on('--sid <connect.sid>',
             "Specify scrapbox's session id extracted from browser's cookie"
            ) { |sid|
      @conf[:sid] = sid
    }
    @opts.on('--export-from <prj name>',
             "Specify the source project name"
            ) { |prj_name|
      @conf[:export_from] = prj_name
    }
    @opts.on('--publish-to <prj name>',
             "Speciry the target project name"
            ) { |prj_name|
      @conf[:publish_to] = prj_name
    }
    @opts.on('--from-json-file </path/to/json/as/source>',
             "Specify the source as a local file, instead of scrapbox"
            ) { |filepath|
      @conf[:from_json_file] = filepath
    }
    @opts.on('--output-original-json </path/to/json/to/write>',
             "Output json of source to file"
            ) { |filepath|
      @conf[:output_original_json] = filepath
    }
    @opts.on('--output-extracted-json </path/to/json/to/write>',
             "Output json to be uploaded of result of process to file"
            ) { |filepath|
      @conf[:output_extracted_json] = filepath
    }
    @opts.on('--dont-publish',
             'DO NOT PUBLISH'
            ) { |dont|
      @conf[:dont_publish] = dont
    }
    @opts.on('--verbose',
             "Increse output verbosity",
            ) { |verbose|
      @conf[:verbose] = verbose
    }

    @conf = {
      :sid => ENV['SCRAPBOX_SID'],
      :export_from => nil,
      :publish_to  => nil,
      :from_json_file => nil,
      :output_original_json  => nil,
      :output_extracted_json => nil,
      :dont_publish => false,
      :verbose => false
    }
    @sbpub = Sbpub.new
  end

  def parse_opts(argv)
    @opts.parse(argv)
  end

  def main
    if !@conf[:sid]
      puts 'Set the value of the connect.sid cookie to the SCRAPBOX_SID environment variable.'
      puts 'More options can be found with --help.'
      exit
    end
    @sbpub.sid = @conf[:sid]

    # Setting target project as json.
    if @conf[:from_json_file] != nil
      # From local json file.
      File.open(@conf[:from_json_file], 'r') do |f|
        puts "Reading from local file #{@conf[:from_json_file]}"
        @sbpub.json = f.read
      end
    else
      # From scrapbox.
      @sbpub.export_from = @conf[:export_from]
      csrf_token = @sbpub._update_csrf_token
      puts "Reading from living scrapbox project #{@conf[:export_from]}"
      @sbpub._export_all_pages_from
      if @conf[:output_original_json] != nil
        # TODO: write json to local file.
      end
    end      

    # Processing json.
    puts "Processing"
    @sbpub._extract_to_publish
    if @conf[:output_extracted_json] != nil
      # TODO: write json to local file.
    end

    # Publishing to other scrapbox project.
    if @conf[:dont_publish] == false
      # publish into other scrapbox project.
      puts "Publishing to #{@conf[:publish_to]}"
      @sbpub.publish_to = @conf[:publish_to]
      @sbpub._update_csrf_token if !csrf_token
      @sbpub._publish_extracted_pages_to
    end

  end

end

app = ScrapboxPublisher.new
app.parse_opts(ARGV)
app.main
