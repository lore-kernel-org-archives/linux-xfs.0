Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 22:33:05 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.224])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8K5Wtuw026569
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 22:33:00 -0700
Received: by wx-out-0506.google.com with SMTP id s9so383227wxc
        for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 22:32:58 -0700 (PDT)
Subject: Re: The problem in installing the linux-2.6-xfs kernel
From: hxsrmeng <hxsrmeng@gmail.com>
Reply-To: hxsrmeng@gmail.com
In-Reply-To: <46F1FB7C.9080901@sandeen.net>
References: <1190260918.24375.4.camel@OpenSUSE-desktop.Home>
	 <46F1FB7C.9080901@sandeen.net>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 01:04:35 -0400
Message-Id: <1190264675.19442.12.camel@OpenSUSE-desktop.Home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: XFS <xfs@oss.sgi.com>

Thanks.

I downloaded this distribution from the cvs@oss.sgi.com, and it is a
XFS-relative kernel, so I think it should be OK for me to post this
question here.

Also, as I mentioned, I am especially interested in playing with the XFS
features and I am worrying whether this problem would stop me in doing
that. I think the gurus who could answer this question should be
here. .... Anyway, I am sorry if you think i post it to a wrong list.


On Wed, 2007-09-19 at 23:47 -0500, Eric Sandeen wrote:
> hxsrmeng wrote:
> > Hi, 
> > 
> > When I do:
> > $/sbin/mkinitrd -k vmlinuz-2.6-xfs -i initrd-2.6-xfs
> 
> mkinitrd varies from distribution to distribution.  I don't know what
> the -k and -i options do in your case.
> 
> But, this really isn't particularly on-topic for the xfs list... if
> you're having trouble installing a custom kernel, I'd suggest asking on
> a list more relevant to your distribution.
> 
> -Eric
> 
> > I got:
> > "
> > Filesystem modules:
> > WARNING: Couldn't open
> > directory /var/tmp/mkinitramfs.C23294/mnt/lib/modules/2.6.23-rc4: No
> > such file or directory
> > FATAL: Could not
> > open /var/tmp/mkinitramfs.C23294/mnt/lib/modules/2.6.23-rc4/modules.dep.temp for writing: No such file or directory
> > "
> > So, does this mean it failed?
> > 
> > If I can still boot this kernel, are the file system features OK?
> > Especially, I want to try XFS and "Concurrent Multi-File Data Streams".
> > 
> > Thanks in advance!
> > 
> > 
> 
