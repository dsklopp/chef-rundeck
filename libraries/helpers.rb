
def read_token(user='admin')
   File.open('/etc/rundeck/tokens.properties').each_line do |line|
      args=line.split
      if args[0][0..-2] == user
         return args[1].strip()
      end
   end
   return nil
end
