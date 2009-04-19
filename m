Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JKtOlG008705 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 15:55:24 -0500
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 9FCB62254B7
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 13:55:16 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id JQWdUquRGqFTPfVQ for <xfs@oss.sgi.com>;
	Sun, 19 Apr 2009 13:55:16 -0700 (PDT)
Message-ID: <49EB8FAF.9060006@gmx.net>
Date: Sun, 19 Apr 2009 22:55:11 +0200
From: Klaus Strebel <klaus.strebel@gmx.net>
MIME-Version: 1.0
Subject: Re: getting changes (fixes or enhancements) to xfs-tools
References: <615709150.3493811239917317690.JavaMail.root@mail-au.aconex.com>
	<49E8D28F.9000500@tlinx.org>
In-Reply-To: <49E8D28F.9000500@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Linda A. Walsh schrieb:
> Nathan Scott wrote:
>>>     I understand you want people to see the work that has gone into
>>> the
>>> kernel, but telling someone to search through 1327 entries just to
>>> find
>>> an answer of 'no', seems a bit ...something.
>>
>> http://git.kernel.org/
>>     fs/xfs/xfsdump-dev.git
>>     fs/xfs/xfsprogs-dev.git
>>     fs/xfs/xfstests-dev.git
>>     fs/xfs/dmapi-dev.git
> ---
>     Those are files from the actual utilities?  I.e. the
> source code for the utilities is stored in the kernel tree?  That the
> support routines for the utilities have changes doesn't imply that
> one would expect to find source-changes for the utils there unless
> the utils are in the kernel tree -- but I don't think so(?)  Like the
> 'util-linux' utils, I have the impression they are stored outside of
> the kernel tree.
>
>     No need to answer to tell me the util sources are not stored
> in the kernel (if that's the case), as that's my current "world view" 
> :-).
> But if I need to update my current world view (again), I hope you'll
> _gently_ let me know. :-)
>
Hi Linda,

your misunderstanding, git.kernel.org is a site where several git 
repositories are hosted, no the kernel source tree ;-). The 
fs/xfs/xxx.git is the path of the git-repository of the xfs-tools, i 
doesn't mean it's in the kernel source in the directory fs/xfs ...
Even the sources for ext2 ( 3, 4 ), btrfs, jfs, reiserfs et al. are not 
part of the Linux source tree, so what made you thinking that?

Cheers
Klaus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
