Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 04:00:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m51B0HYF019354
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 04:00:18 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2D391D87B2
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2008 04:01:10 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id 4xB5N9iONjjThQPW for <xfs@oss.sgi.com>; Sun, 01 Jun 2008 04:01:10 -0700 (PDT)
Date: Sun, 1 Jun 2008 07:01:09 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s
 peak for read, ~650MiB/s peak for write?
In-Reply-To: <alpine.DEB.1.10.0806010539430.24757@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0806010700170.10729@p34.internal.lan>
References: <alpine.DEB.1.10.0806010539430.24757@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com


On Sun, 1 Jun 2008, Justin Piszcz wrote:

> I have 12 enterprise-class seagate 1TiB disks on a 965 desktop board and it 
> appears I have hit the limit, if I were able to get the maximum speed of all 
> drives, ~70MiB/avg * 12 = 840MiB/s but it seems to stop aound 774 MiB/s 
> (currently running badblocks on all drives)..

Small correction, they are 7200.11 Seagate Desktop Drives (ST31000340AS), 
not enterprise drives:

http://www.seagate.com/ww/v/index.jsp?vgnextoid=0732f141e7f43110VgnVCM100000f5ee0a0aRCRD
http://www.newegg.com/Product/Product.aspx?Item=N82E16822148274
