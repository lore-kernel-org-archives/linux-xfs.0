Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Feb 2008 00:44:47 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1K8idPT003662
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 00:44:43 -0800
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE455E70744
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 00:45:04 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.171]) by cuda.sgi.com with ESMTP id Hru4npBRQqOoc00s for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 00:45:04 -0800 (PST)
Message-ID: <47BBE88C.1020801@gmx.net>
Date: Wed, 20 Feb 2008 09:45:00 +0100
From: Klaus Strebel <klaus.strebel@gmx.net>
MIME-Version: 1.0
Subject: Re: Is CVS stable?
References: <eb736a810802200026g1b956abar922548d3e67a9682@mail.gmail.com>
In-Reply-To: <eb736a810802200026g1b956abar922548d3e67a9682@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: eric c <xcellula@gmail.com>
Cc: xfs@oss.sgi.com

eric c schrieb:
> Hello,
> 
> I have recently seen some patches for slabcache related
> xfs_inode/xfs_vnode_t/dentry_cache taking up alot of memory:
>   http://oss.sgi.com/archives/xfs/2007-12/msg00154.html
>   http://oss.sgi.com/archives/xfs/2008-02/msg00138.html
> 
> If I cvs on linux-2.6-xfs, is it stable for production or bleeding?

Hi Eric,

im running cvs since 14th Feb. quite stable on my home laptop ( well, 
some days before, there was this funny thing with the slabcache which 
caused a nice deadlock on shutdown ). I use the cvs kernels since ... 
well, years ... and they are mostly stable, but it is always a good idea 
to have a working kernel bootable.

At the moment it is still 2.6.24-rcX, the guys at SGI seem to be very 
busy, so nobody did the update to 2.6.24 ( or 2.6.25-rc2 ).

Ciao
Klaus


-- 
Mit freundlichen Grüssen / best regards

Klaus Strebel, Dipl.-Inform. (FH), mailto:klaus.strebel@gmx.net

/"\
\ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
/ \
