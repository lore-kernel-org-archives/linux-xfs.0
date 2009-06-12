Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5C6DNLL191986 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 01:13:23 -0500
Received: from mail-px0-f194.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5B43120B5AE
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 23:21:04 -0700 (PDT)
Received: from mail-px0-f194.google.com (mail-px0-f194.google.com
	[209.85.216.194]) by cuda.sgi.com with ESMTP id
	MDAYGy59h7FG8Ffx for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2009 23:21:04 -0700 (PDT)
Received: by pxi32 with SMTP id 32so1471208pxi.20
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 23:13:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090612054932.GA15781@jdc.jasonjgw.net>
References: <4A31E0FF.8050400@tlinx.org>
	<921ca19c0906112227m2c834808jd62b15d0203fe4e3@mail.gmail.com>
	<20090612054932.GA15781@jdc.jasonjgw.net>
Date: Fri, 12 Jun 2009 11:43:44 +0530
Message-ID: <921ca19c0906112313k70f8999w262bd65468eee3c0@mail.gmail.com>
Subject: Re: grub no longer being maintained? drops support for XFS?
From: Sujit Karataparambil <sjt.kar@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I am running Ubuntu 8.10 Server. As the defect resolution says, As
I am installing XFS/Upgrading to XFS, Tries to Install Lilo which too
it fails. Might be specific to Ubuntu 8.10. The Kernel is 2.6.26 I think.

On Fri, Jun 12, 2009 at 11:19 AM, Jason White<jason@jasonjgw.net> wrote:
> Sujit Karataparambil <sjt.kar@gmail.com> wrote:
>> This is an Known Issue. Grub hangs when used With XFS. You could
>> Try Lilo instead.
>
> Grub in the master boot record works for me with XFS as the only file system
> on the disk. These are Debian machines, in case that makes a difference.
>
> Grub 2 might have better support for XFS.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- 
-- Sujit K M

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
