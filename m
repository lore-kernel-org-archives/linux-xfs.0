Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5BFD57CA2
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 14:33:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F036304059
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 12:33:55 -0700 (PDT)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
	[81.169.146.216]) by cuda.sgi.com with ESMTP id
	D4YE0ezzdtWw91eB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 12:33:53 -0700 (PDT)
Date: Wed, 30 Mar 2016 21:33:51 +0200
From: Olaf Hering <olaf@aepfle.de>
Subject: Re: BUG in xfs_trans_binval
Message-ID: <20160330193351.GA18130@aepfle.de>
References: <20160329171553.GA17885@aepfle.de> <20160329235415.GF30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160329235415.GF30721@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 30, Dave Chinner wrote:

> Can you run a memory tester on the machine?

Thanks for taking time to respond.

memtest did not find anything. Since it is essentially a scratch
partition doing a mkfs would work for me.

Olaf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
