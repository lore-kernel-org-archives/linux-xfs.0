Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9L2Njw0196025 for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 21:23:45 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2FA311B92E4
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 19:25:19 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id jHVLql20fBcrUacx for
	<xfs@oss.sgi.com>; Tue, 20 Oct 2009 19:25:19 -0700 (PDT)
Message-ID: <4ADE710C.3020107@tlinx.org>
Date: Tue, 20 Oct 2009 19:25:16 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs_fsr: XFS_IOC_SWAPEXT failed; & miscellania
References: <4ADD4D9B.9090808@tlinx.org> <4ADE33D5.6080907@sandeen.net>
	<4ADE6ED8.20003@tlinx.org> <4ADE6F78.5020609@sandeen.net>
In-Reply-To: <4ADE6F78.5020609@sandeen.net>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Linda A. Walsh asked:
>> 4) is it possible to configure the xfs_utils with 'readline' and history
> 
> current upstream has fixed readline support:
> 
> d2e43158ae65863df2d5310381ed316f8e6871ce xfsprogs: fix readline/editline 
> for xfs_io and xfs_quota
>  
> -Eric

Excellent.

If I have time, will have to figure out how to pull that down -- no telling when it
will appear in my distro (of course no telling when it went into the upstream)...
(Of course by the time I have the time, to do it, they may have it in there as
well! :-)).

Does upstream mean available via some publically available source retrieval?
cvs, subversion, ... whatever xfs uses...?

-l

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
