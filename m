Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 21:48:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8K4m1uw020705
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 21:48:02 -0700
Message-ID: <46F1FB7C.9080901@sandeen.net>
Date: Wed, 19 Sep 2007 23:47:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: The problem in installing the linux-2.6-xfs kernel
References: <1190260918.24375.4.camel@OpenSUSE-desktop.Home>
In-Reply-To: <1190260918.24375.4.camel@OpenSUSE-desktop.Home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: hxsrmeng@gmail.com
Cc: XFS <xfs@oss.sgi.com>

hxsrmeng wrote:
> Hi, 
> 
> When I do:
> $/sbin/mkinitrd -k vmlinuz-2.6-xfs -i initrd-2.6-xfs

mkinitrd varies from distribution to distribution.  I don't know what
the -k and -i options do in your case.

But, this really isn't particularly on-topic for the xfs list... if
you're having trouble installing a custom kernel, I'd suggest asking on
a list more relevant to your distribution.

-Eric

> I got:
> "
> Filesystem modules:
> WARNING: Couldn't open
> directory /var/tmp/mkinitramfs.C23294/mnt/lib/modules/2.6.23-rc4: No
> such file or directory
> FATAL: Could not
> open /var/tmp/mkinitramfs.C23294/mnt/lib/modules/2.6.23-rc4/modules.dep.temp for writing: No such file or directory
> "
> So, does this mean it failed?
> 
> If I can still boot this kernel, are the file system features OK?
> Especially, I want to try XFS and "Concurrent Multi-File Data Streams".
> 
> Thanks in advance!
> 
> 
