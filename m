Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n77ECK3T135678 for <xfs@oss.sgi.com>; Fri, 7 Aug 2009 09:12:20 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A35DF146AF3B
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2009 07:13:11 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id YRr0ZGmYbk6KkCP4 for
	<xfs@oss.sgi.com>; Fri, 07 Aug 2009 07:13:11 -0700 (PDT)
Message-ID: <4A7C3676.1050303@sandeen.net>
Date: Fri, 07 Aug 2009 09:13:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs_repair - clear inodes in incorrect btree format
References: <4A7C255F.4010001@zmensch.de>
In-Reply-To: <4A7C255F.4010001@zmensch.de>
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
To: Zoran Cvetkovic <Zoran.Cvetkovic@zmensch.de>
Cc: xfs@oss.sgi.com

Zoran Cvetkovic wrote:
> Hello,
> 
> my today posting with subject: "corrupt dinode but xfs_check and 
> xfs_repair are bit detecting any problem and are fixing nothing"
> seems to be a the same issue.
> 
> I will provide the methadump to whom it my be help full.
> 
> Regards,
> Zoran Cvetkovic

If you like, it's in git at
http://git.kernel.org/?p=fs/xfs/xfsprogs-dev.git;a=summary

and you could make test that on a metadump youreslf.

Otherwise, I could take a look.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
