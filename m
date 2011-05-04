Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44Dj5GE078025 for <xfs@oss.sgi.com>; Wed, 4 May 2011 08:45:05 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39299C3D805
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 06:48:42 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id AwJpdYMnXJ7LuvlN for <xfs@oss.sgi.com>;
	Wed, 04 May 2011 06:48:42 -0700 (PDT)
Message-ID: <4DC15939.5020508@sandeen.net>
Date: Wed, 04 May 2011 08:48:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: clean up fallocate configuration tests
References: <4DBF492E.3040400@sandeen.net>
	<4DC0516F.2040108@linux.vnet.ibm.com>
In-Reply-To: <4DC0516F.2040108@linux.vnet.ibm.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 5/3/11 2:03 PM, Allison Henderson wrote:

> Thanks Eric,
> 
> I tried it out and it looks like it works great.  I will back out the changes to the Makefile in my fsx patch.
> 
> Allison Henderson
> 

Thanks; I pushed it to the xfstests-dev git tree, you should be able to pull it and rebase your patches in a few minutes.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
