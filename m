Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3HJ3vbq151942 for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 14:03:57 -0500
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5ACFE142E0DF
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 12:06:10 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id jLaOF37GMr9r2v7g for
	<xfs@oss.sgi.com>; Fri, 17 Apr 2009 12:06:10 -0700 (PDT)
Message-ID: <49E8D28F.9000500@tlinx.org>
Date: Fri, 17 Apr 2009 12:03:43 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: getting changes (fixes or enhancements) to xfs-tools
References: <615709150.3493811239917317690.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <615709150.3493811239917317690.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nscott@aconex.com>, xfs-oss <xfs@oss.sgi.com>

Nathan Scott wrote:
>>     I understand you want people to see the work that has gone into
>> the
>> kernel, but telling someone to search through 1327 entries just to
>> find
>> an answer of 'no', seems a bit ...something.
> 
> http://git.kernel.org/
>     fs/xfs/xfsdump-dev.git
>     fs/xfs/xfsprogs-dev.git
>     fs/xfs/xfstests-dev.git
>     fs/xfs/dmapi-dev.git
---
	Those are files from the actual utilities?  I.e. the
source code for the utilities is stored in the kernel tree?  That the
support routines for the utilities have changes doesn't imply that
one would expect to find source-changes for the utils there unless
the utils are in the kernel tree -- but I don't think so(?)  Like the
'util-linux' utils, I have the impression they are stored outside of
the kernel tree.

	No need to answer to tell me the util sources are not stored
in the kernel (if that's the case), as that's my current "world view" :-).
But if I need to update my current world view (again), I hope you'll
_gently_ let me know. :-)

linda




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
