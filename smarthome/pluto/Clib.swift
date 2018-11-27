//
//  Clib.swift
//  smarthome
//
//  Created by lu on 2018/10/25.
//  Copyright © 2018年 jifan. All rights reserved.
//

import Foundation

final public class Clib{
    public static func getUnixTime()->UInt64{
        let now = NSDate()
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970;
        let timeStamp = UInt64(timeInterval);
        return timeStamp;
    }
    public static func U16toB(value:UInt16)->[UInt8] {
        var buf:[UInt8] = [UInt8]();
        buf.append(((value >> 8) & 0x00ff).toU8);
        buf.append(((value) & 0x00ff).toU8);
        return buf;
    }
    public static func U32toB(value:UInt32)->[UInt8] {
        var buf:[UInt8] = [UInt8]();
        buf.append(((value >> 24) & 0x00ff).toU8);
        buf.append(((value >> 16) & 0x00ff).toU8);
        buf.append(((value >> 8) & 0x00ff).toU8);
        buf.append(((value) & 0x00ff).toU8);
        return buf;
    }
    public static func BtoU32(pdata:[UInt8],startIndex:Int,bytes:Int)->UInt32{
        var temp:UInt32 = 0;
        for i in 0...(bytes-1){
            temp <<= 8;
            temp |= pdata[startIndex+i].toU32;
        }
        return temp;
    }
    public static func loopSub(left:UInt64,right:UInt64)->UInt64{
        if(left>right)
        {
            return (left-right);
        }
        else
        {
            return (0xFFFFFFFFFFFFFFFF-right+left);
        }
    }
    public static func loopSub(left:UInt32,right:UInt32)->UInt32{
        if(left>right)
        {
            return (left-right);
        }
        else
        {
            return (0xFFFFFFFF-right+left);
        }
    }
    public static func cut_Uint8_arrary(arrary:[UInt8], start:Int, len:Int)->[UInt8]{
        var buf:[UInt8] = [UInt8]();
        for i in 0...(len-1){
            if i<arrary.count{
                buf.append(arrary[i+start]);
            }
        }
        return buf;
    }
    public static func hex_to_byte(ch:Character)->UInt8{
        switch(ch){
        case "0":return 0;
        case "1":return 1;
        case "2":return 2;
        case "3":return 3;
        case "4":return 4;
        case "5":return 5;
        case "6":return 6;
        case "7":return 7;
        case "8":return 8;
        case "9":return 9;
        case "a":return 10;
        case "A":return 10;
        case "b":return 11;
        case "B":return 11;
        case "c":return 12;
        case "C":return 12;
        case "d":return 13;
        case "D":return 13;
        case "e":return 14;
        case "E":return 14;
        case "f":return 15;
        case "F":return 15;
        default:return 0;
        }
    }
    private static let CRC16Table:[UInt16] =
    [
    0x0000,0xC0C1,0xC181,0x0140,0xC301,0x03C0,0x0280,0xC241,
    0xC601,0x06C0,0x0780,0xC741,0x0500,0xC5C1,0xC481,0x0440,
    0xCC01,0x0CC0,0x0D80,0xCD41,0x0F00,0xCFC1,0xCE81,0x0E40,
    0x0A00,0xCAC1,0xCB81,0x0B40,0xC901,0x09C0,0x0880,0xC841,
    0xD801,0x18C0,0x1980,0xD941,0x1B00,0xDBC1,0xDA81,0x1A40,
    0x1E00,0xDEC1,0xDF81,0x1F40,0xDD01,0x1DC0,0x1C80,0xDC41,
    0x1400,0xD4C1,0xD581,0x1540,0xD701,0x17C0,0x1680,0xD641,
    0xD201,0x12C0,0x1380,0xD341,0x1100,0xD1C1,0xD081,0x1040,
    0xF001,0x30C0,0x3180,0xF141,0x3300,0xF3C1,0xF281,0x3240,
    0x3600,0xF6C1,0xF781,0x3740,0xF501,0x35C0,0x3480,0xF441,
    0x3C00,0xFCC1,0xFD81,0x3D40,0xFF01,0x3FC0,0x3E80,0xFE41,
    0xFA01,0x3AC0,0x3B80,0xFB41,0x3900,0xF9C1,0xF881,0x3840,
    0x2800,0xE8C1,0xE981,0x2940,0xEB01,0x2BC0,0x2A80,0xEA41,
    0xEE01,0x2EC0,0x2F80,0xEF41,0x2D00,0xEDC1,0xEC81,0x2C40,
    0xE401,0x24C0,0x2580,0xE541,0x2700,0xE7C1,0xE681,0x2640,
    0x2200,0xE2C1,0xE381,0x2340,0xE101,0x21C0,0x2080,0xE041,
    0xA001,0x60C0,0x6180,0xA141,0x6300,0xA3C1,0xA281,0x6240,
    0x6600,0xA6C1,0xA781,0x6740,0xA501,0x65C0,0x6480,0xA441,
    0x6C00,0xACC1,0xAD81,0x6D40,0xAF01,0x6FC0,0x6E80,0xAE41,
    0xAA01,0x6AC0,0x6B80,0xAB41,0x6900,0xA9C1,0xA881,0x6840,
    0x7800,0xB8C1,0xB981,0x7940,0xBB01,0x7BC0,0x7A80,0xBA41,
    0xBE01,0x7EC0,0x7F80,0xBF41,0x7D00,0xBDC1,0xBC81,0x7C40,
    0xB401,0x74C0,0x7580,0xB541,0x7700,0xB7C1,0xB681,0x7640,
    0x7200,0xB2C1,0xB381,0x7340,0xB101,0x71C0,0x7080,0xB041,
    0x5000,0x90C1,0x9181,0x5140,0x9301,0x53C0,0x5280,0x9241,
    0x9601,0x56C0,0x5780,0x9741,0x5500,0x95C1,0x9481,0x5440,
    0x9C01,0x5CC0,0x5D80,0x9D41,0x5F00,0x9FC1,0x9E81,0x5E40,
    0x5A00,0x9AC1,0x9B81,0x5B40,0x9901,0x59C0,0x5880,0x9841,
    0x8801,0x48C0,0x4980,0x8941,0x4B00,0x8BC1,0x8A81,0x4A40,
    0x4E00,0x8EC1,0x8F81,0x4F40,0x8D01,0x4DC0,0x4C80,0x8C41,
    0x4400,0x84C1,0x8581,0x4540,0x8701,0x47C0,0x4680,0x8641,
    0x8201,0x42C0,0x4380,0x8341,0x4100,0x81C1,0x8081,0x4040
    ];
    public static func  CRC16(crc:UInt16, pdata:[UInt8],pos:Int,len:Int)->UInt16
    {
        var crc16:UInt16 = crc;
        var slen:Int;
        if (pdata.count>len){
            slen = len
        }
        else{
            slen = pdata.count;
        }
        for i in pos...slen//(i=pos; (i<pdata.length)&&(i<(len+pos)); i++)
        {
            crc16 = (((crc16&0x00FFFF)>>8) ^ Clib.CRC16Table[(crc16&0x00ff).toInt] ^ (pdata[i]&0x00ff).toU16);
        //crc16 = (((crc16&0x00ffff) >> 8) ^ CRC16Table[(crc16 & 0x00FF) ^ ((int)pdata[i]&0x00ff)];
        }
        return crc16;
    }
}