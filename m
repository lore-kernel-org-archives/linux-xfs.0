Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1QFkfIV259882 for <xfs@oss.sgi.com>; Thu, 26 Feb 2009 09:46:42 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F7A21580D3
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2009 07:46:11 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id CUxFT0PRuDlESdLT for <xfs@oss.sgi.com>;
	Thu, 26 Feb 2009 07:46:11 -0800 (PST)
Message-ID: <49A6B93F.6010807@sandeen.net>
Date: Thu, 26 Feb 2009 09:46:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS_repair and memory consumption
References: <49A67288.5060301@poczta.onet.pl>
In-Reply-To: <49A67288.5060301@poczta.onet.pl>
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
To: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Cc: xfs@oss.sgi.com

aluno3@poczta.onet.pl wrote:
> Hello
> 
> I have a few question about xfs_repair and memory consumption
> 
> I have 12 TB storage,2GB RAM and 2.6.27 32b and someday my power down.
> After started system, I tried xfs_repair for this storage (because I
> can`t mount this) with unsuccessful. Maybe I am in the wrong but I know
> that xfs_repair need about 2GB of memory per terabyte of file system space.

Just to double check; were you unsuccessful due to ENOMEM?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
