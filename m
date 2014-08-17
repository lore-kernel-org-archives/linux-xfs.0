Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D2EBC7F3F
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 13:21:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A3C988F8037
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 11:21:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rSEtW7pzVAv9cJcZ for <xfs@oss.sgi.com>;
	Sun, 17 Aug 2014 11:21:17 -0700 (PDT)
Message-ID: <53F0F29C.3080707@sandeen.net>
Date: Sun, 17 Aug 2014 13:21:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Help setting up XFS
References: <BLU181-W306A7E4DE2F035EA4530139CD70@phx.gbl>
In-Reply-To: <BLU181-W306A7E4DE2F035EA4530139CD70@phx.gbl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Prithvi Rathore <prithvi_rathore@outlook.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

You don't yet need xfs-specific information, I think you need some
very basic linux help.  There is a lot of it out there if you look,
for example:

https://www.google.com/search?q=how+to+format+a+usb+drive+with+linux

-Eric

On 8/16/14, 9:06 PM, Prithvi Rathore wrote:
> Hi,
>     I am a student currently pursuing my under-graduation and would love to use XFS. I believe it has a lot to offer and I Iook forwarding to testing and using it on an external device like a pen-drive (USB) for starters.
>     I was a bit confused on how to set up XFS. I am currently using Ubuntu 14.04 dual boot (via rEFInd) with Mac OS X on MacBook Air 2013. 
>     The various documentation available at xfs.org, surely is very informative and provides an elaborate description on XFS features. Setting XFS up however is where i am a bit stuck. From the various online material available, I found the following ways:
> 
> 1) From terminal
>      # sudo apt-get install xfsprogs 
>      # sudo apt-get install xfsdump
>     I believe it sets up the version 3.1.9.
> 
> 2) Another method was, that i tried was downloading the tar file from the sgi link. It downloaded xfs-progs-   
>     3.2.1.tar.gz   
> 
> 3) From various discussions done online i found people changing a few settings in the $ make menuconfig GUI 
>     screen, hence adding support for XFS.
> 
>    I am also a bit confused on how to use the device name (USB pen drive) when i will run the mkfs.xfs as I heard it doesn't work for a mounted device.
>   I know you may be busy and my mail might seem a bit amateur, but I would really appreciate if you could guide me on how to setup XFS and run it for a USB device. Any link explaining the same would also be really appreciated. Thank you.
> 
> Warm Regards
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
