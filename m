Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SG3ZQn200623 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 10:03:36 -0600
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	0sZW7NyMUbLagqke (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 08:03:32 -0800 (PST)
Received: by iaoo28 with SMTP id o28so4862791iao.26
	for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 08:03:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329957699-20769-1-git-send-email-kdasu.kdev@gmail.com>
References: <kdasu.kdev@gmail.com>
	<1329957699-20769-1-git-send-email-kdasu.kdev@gmail.com>
Date: Tue, 28 Feb 2012 11:03:31 -0500
Message-ID: <CAC=U0a0Y2mL9DtYU1gWf0Qvjop97YPQ2g_m6mo9czdyW-atDdQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix deadlock in xfs_rtfree_extent with kernel v3.x
From: Kamal Dasu <kdasu.kdev@gmail.com>
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

Adding reference to the related thread for an older kernel :

<a href="http://old.nabble.com/forum/ViewPost.jtp?post=33405297&framed=y">http://old.nabble.com/forum/ViewPost.jtp?post=33405297&framed=y</a>

Kamal

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
