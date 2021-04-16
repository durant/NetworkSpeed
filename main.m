//
//  main.m
//  RouteDemo
//
//  Created by devin on 2021/3/4.
//

#import <Cocoa/Cocoa.h>

#import "NetSpeed.h"

void test_speed() {
    
    const char *if_name = "en0";
    
    struct if_speed ndev;
    int ret = 0;
 
    bzero(&ndev,sizeof(ndev));
    sprintf(ndev.ifs_name,"%s", if_name);
 
    ndev.ifs_us = 2000000;

    printf("Get %s Speed",if_name);
    ret = get_if_speed(&ndev);
    if(ret < 0)
        printf("\t\t\t[Fail]\n");
    else
        printf("\t\t\t[OK]\n");
    float ispeed ,ospeed;
    while(1){
        ispeed = ndev.ifs_ispeed * 1.0/(ndev.ifs_us/1000 * 0.001);
        ospeed = ndev.ifs_ospeed * 1.0/(ndev.ifs_us/1000 * 0.001);
 
        printf("%s: Up Speed: %.2f kb/s || Down Speed: %.2f kb/s\r",ndev.ifs_name,ospeed/1024.0,ispeed/1024.0);

        get_if_speed(&ndev);
    }
}

int main(int argc, const char * argv[]) {
    test_speed();
    return 0;
}
