Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 09:10:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8KG9qgf020738
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 09:09:55 -0700
Message-ID: <46F26E9F.8060803@sandeen.net>
Date: Thu, 20 Sep 2007 07:59:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: The problem in installing the linux-2.6-xfs kernel
References: <1190260918.24375.4.camel@OpenSUSE-desktop.Home>	 <46F1FB7C.9080901@sandeen.net> <1190264675.19442.12.camel@OpenSUSE-desktop.Home>
In-Reply-To: <1190264675.19442.12.camel@OpenSUSE-desktop.Home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: hxsrmeng@gmail.com
Cc: XFS <xfs@oss.sgi.com>

hxsrmeng wrote:
> Thanks.
> 
> I downloaded this distribution from the cvs@oss.sgi.com, and it is a
> XFS-relative kernel, so I think it should be OK for me to post this
> question here.

I am talking about the gnu/linux OS distribution that already exists on
your computer (debian, red hat, mandrake, suse, ubuntu whatever).  How
you install a new kernel, particularly how you make an initrd, is
somewhat specific to that distribution, not to the kernel itself.  In
other words, mkinitrd failures are not xfs related.

> Also, as I mentioned, I am especially interested in playing with the XFS
> features and I am worrying whether this problem would stop me in doing
> that. I think the gurus who could answer this question should be
> here. .... Anyway, I am sorry if you think i post it to a wrong list.

If you can't boot and can't load xfs, it won't work.  If you can, it will.

-Eric
