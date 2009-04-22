Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3MJA9VQ219370 for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 14:10:09 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 057A4143F54F
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 12:12:53 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id VHpkc82AZnFw01LE for
	<xfs@oss.sgi.com>; Wed, 22 Apr 2009 12:12:53 -0700 (PDT)
Date: Wed, 22 Apr 2009 15:10:04 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] xfstests: filter out imaxpct value in test 096
Message-ID: <20090422191004.GA3709@josefsipek.net>
References: <49EE2664.7030701@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49EE2664.7030701@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Tue, Apr 21, 2009 at 03:02:44PM -0500, Eric Sandeen wrote:
> xfstests: filter out imaxpct value in test 096
> 
> On large filesystems, imaxpc drops from 25 to 5
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Makes sense.

Josef 'Jeff' Sipek.

-- 
What is the difference between Mechanical Engineers and Civil Engineers?
Mechanical Engineers build weapons, Civil Engineers build targets.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
