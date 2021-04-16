//
//  NetSpeed.m
//  RouteDemo
//
//  Created by devin on 2021/4/15.
//

#import "NetSpeed.h"

#include <assert.h>
#include <unistd.h>
#include <net/if_var.h>
#include <net/if.h>

@implementation NetSpeed

int get_if_dbytes(struct if_info* ndev)
{
    assert(ndev);
    
    struct ifaddrs *ifa_list = NULL;
    struct ifaddrs *ifa = NULL;
    struct if_data *ifd = NULL;
    int     ret = 0;
    
    ret = getifaddrs(&ifa_list);
    if(ret < 0) {
        perror("Get Interface Address Fail:");
        goto end;
    }
    
    for(ifa=ifa_list; ifa; ifa=ifa->ifa_next){
        ret = strcmp(ifa->ifa_name,ndev->ifi_name);
        if (ret == 0) {
            if(!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) {
                break;
            }
            if(ifa->ifa_data == 0)
                continue;
            
            if(ret == 0){
               ifd = (struct if_data *)ifa->ifa_data;
               
               ndev->ifi_ibytes_1 = ifd->ifi_ibytes;
               ndev->ifi_obytes_1 = ifd->ifi_obytes;
               break;
            }
        }
    }
 
    freeifaddrs(ifa_list);
end:
    return (ret ? -1 : 0);
}
 
int get_if_speed(struct if_speed *ndev)
{
    assert(ndev);
 
    struct if_info *p1=NULL,*p2=NULL;
 
    p1 = (struct if_info *)malloc(sizeof(struct if_info));
    p2 = (struct if_info *)malloc(sizeof(struct if_info));
    bzero(p1,sizeof(struct if_info));
    bzero(p2,sizeof(struct if_info));
 
    strncpy(p1->ifi_name,ndev->ifs_name,strlen(ndev->ifs_name));
    strncpy(p2->ifi_name,ndev->ifs_name,strlen(ndev->ifs_name));
 
    int ret = 0;
    ret = get_if_dbytes(p1);
    usleep((useconds_t)ndev->ifs_us);
    if(ret < 0) {
        goto end;
    }
    ret = get_if_dbytes(p2);
    if(ret < 0) {
        goto end;
    }
 
    ndev->ifs_ispeed = p2->ifi_ibytes_1 - p1->ifi_ibytes_1;
    ndev->ifs_ospeed = p2->ifi_obytes_1 - p1->ifi_obytes_1;
 
end:
    free(p1);
    free(p2);
 
    return 0;
}

@end
