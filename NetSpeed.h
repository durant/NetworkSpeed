//
//  NetSpeed.h
//  RouteDemo
//
//  Created by devin on 2021/4/15.
//

#import <Foundation/Foundation.h>

#include <sys/stat.h>
#include <ifaddrs.h>


//struct if_data
//{
//    /*  generic interface information */
//    u_long ifi_opackets;    /*  packets sent on interface */
//    u_long ifi_ipackets;    /*  packets received on interface */
//    u_long ifi_obytes;      /*  total number of octets sent */
//    u_long ifi_ibytes;      /*  total number of octets received */
//};
    
struct if_info
{
    char ifi_name[16];
    unsigned long ifi_ibytes_1;
    unsigned long ifi_obytes_1;
};

struct if_speed
{
    char ifs_name[16];
    unsigned long ifs_ispeed;
    unsigned long ifs_ospeed;
    unsigned long ifs_us;
};

@interface NetSpeed : NSObject

int get_if_dbytes(struct if_info* ndev);

int get_if_speed(struct if_speed *ndev);

@end
