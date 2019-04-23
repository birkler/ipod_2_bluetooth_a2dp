import serial
import time

ser = serial.Serial() # open serial port

ser.port = '/dev/ttyUSB0'

ser.baudrate = 19200
ser.bytesize = serial.EIGHTBITS
ser.parity = serial.PARITY_NONE
ser.stopbits = serial.STOPBITS_TWO
ser.rts = 0
ser.timeout = 1


def send_mode4_response(list):
    time.sleep(0.005)
    command_parameters = serial.to_bytes(list)
    header = bytearray(4)
    header[0] = 0xFF
    header[1] = 0x55
    header[2] = 1 + len(command_parameters)
    header[3] = 0x04
    checksum = header[2] + header[3]
    for d in command_parameters:
        checksum += d

    checksum &= 0xFF
    checksum = 0x100 - checksum
    checksum &= 0xFF

    data = bytearray()
    data.extend(header)
    data.extend(command_parameters)
    data.append(checksum)

    ser.write(serial.to_bytes(data))

    print(data.hex())




class CommandHandler(object):

    def dispatch_command(self,mode, command_parameters):
        command = command_parameters[0]*255 + command_parameters[1]
        if (mode == 0):
            print("mode switching to %02X" % command)
            return 0
        elif (mode == 4):
            hex_str = command_parameters.hex()
            s_dbg = 'mode 4 %04X %s' % (command, hex_str)
            print(s_dbg)
            """Dispatch method"""
            # prefix the method_name with 'number_' because method names
            # cannot begin with an integer.

            method_name = 'command_%04X' % command
            # Get the method from 'self'. Default to a lambda.
            print("Calling method %s" % method_name)
            method = getattr(self, method_name, lambda cmd_params: self.command_unknown(command_parameters))
            # Call the method as we return it

            return method(command_parameters)
        else:
            print("mode:%d switching to %02X" % (mode,command))
            return 1

    def send_default_ack(self,command_parameters):
        send_mode4_response([0x00,0x01,0x00,command_parameters[0],command_parameters[1]])
        return 0

    def command_unknown(self,command_parameters):
        print("unknown cmd: %02X%02X" % (command_parameters[0],command_parameters[1]))
        self.send_default_ack(command_parameters)
        return 0

    def command_0002(self,command_parameters):
        """Ping"""
        send_mode4_response([0x00,0x03,0xFF,0xFF,0xFF,0xFF,0x00,0x00,0x00,0x00])
        return 0


    def command_0012(self,command_parameters):
        """Get ipod size/model"""
        send_mode4_response([0x00,0x13,0x01,0x0e])
        return 0

    def command_0014(self,command_parameters):
        """Get ipod name"""
        send_mode4_response([0x00,0x13,'a','b',0x00])
        return 0

    def command_0016(self,command_parameters):
        """playlist0"""
        self.send_default_ack(command_parameters)
        return 0

    def command_0018(self,command_parameters):
        """get #count of type"""
        type_req = command_parameters[3]
        send_mode4_response([0x00,0x19,0x00,0x00,0x00,0x00])
        return 0

    def command_001C(self,command_parameters):
        """Track length in milliseconds, elapsed time in milliseconds, status=0x0 stop, 0x01 playing, 0x02 paused"""
        type_req = command_parameters[2]
        send_mode4_response([0x00,0x1D,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01])
        return 0

    def command_001E(self,command_parameters):
        """Track length in milliseconds, elapsed time in milliseconds, status=0x0 stop, 0x01 playing, 0x02 paused"""
        type_req = command_parameters[2]
        send_mode4_response([0x00,0x1F,0x00,0x00,0x00,0x00])
        return 0

    def command_002C(self,command_parameters):
        """get shuffle mode"""
        send_mode4_response([0x00,0x2D,0x00])
        return 0

    def command_002F(self,command_parameters):
        """get repet mode"""
        send_mode4_response([0x00,0x30,0x00])
        return 0

    def command_0026(self,command_parameters):
        """start polling mode"""
        self.send_default_ack(command_parameters)
        return 0

    def command_0029(self,command_parameters):
        """command"""
        cmd_action = command_parameters[2]
        """self.send_default_ack(command_parameters);"""
        return 0

    def command_0033(self,command_parameters):
        """pic size"""
        send_mode4_response([0x00,0x34,0x00,0x00,0x00,0x00,0x01])
        return 0

    def command_0035(self,command_parameters):
        """# songs in playlist"""
        send_mode4_response([0x00,0x36,0x00])
        return 0


cmndHandler = CommandHandler()

while (1):
    try:
        if (not ser.is_open):
            ser.open()

        if (ser.is_open):
            print(ser.name) # check which port was really used


        while (1):
            data = ser.read(4)
            if (len(data) == 4):
                head0 = data[0]
                head1 = data[1]

                if (head0 == 0xFF  and head1 == 0x55):
                    length= data[2]
                    mode = data[3]
                    read_length = length
                    command_parameters = ser.read(read_length)
                    print("%s%s"  % (data.hex(),command_parameters.hex() ))
                    if (len(command_parameters) == read_length):
                        cmndHandler.dispatch_command(mode,command_parameters)


    except Exception as e:
        print(e)


    time.sleep(5)
    


