Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 53A017F37
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 21:54:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40D99304048
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 19:54:37 -0700 (PDT)
Received: from moltke.seatribe.se (moltke.seatribe.se [178.63.100.209]) by
	cuda.sgi.com with ESMTP id pk2RkATLx0PUPFlH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Oct 2013 19:54:37 -0700 (PDT)
Date: Sun, 13 Oct 2013 04:54:32 +0200 (CEST)
From: Fredrik Tolf <fredrik@dolda2000.com>
Subject: Re: Corruption errors with growfs
In-Reply-To: <20131004115253.GI4446@dastard>
Message-ID: <alpine.DEB.2.10.1310130453340.3223@shack.dolda2000.com>
References: <alpine.DEB.2.10.1310040905380.3223@shack.dolda2000.com>
	<20131004115253.GI4446@dastard>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, 4 Oct 2013, Dave Chinner wrote:
> To fix this, you need to grab xfsprogs from the git repo
> (3.2.0-alpha will do) as this commit to xfs_repair detects and fixes
> the corrupted superblocks

I see; that makes sense. Thanks a lot!

--
Fredrik Tolf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
