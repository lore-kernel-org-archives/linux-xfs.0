Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q72Hgelv212506 for <xfs@oss.sgi.com>; Thu, 2 Aug 2012 12:42:40 -0500
Date: Thu, 2 Aug 2012 12:42:37 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: XFS Recovery Behaviour
Message-ID: <20120802174237.GB11592@sgi.com>
References: <5019C5F9.1080302@ashurst.eu.org> <5019C89D.2020303@ashurst.eu.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5019C89D.2020303@ashurst.eu.org>
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
To: Andy Bennett <andyjpb@ashurst.eu.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 02, 2012 at 01:23:57AM +0100, Andy Bennett wrote:
| Hi,
| 
| > I didn't expect to see the import-2012-07-04/ directory again and I
| > certainly didn't expect to see it populated with the card-2/ subdirectory.
| 
| I've been moving the files to my archive disk and now import-2012-07-28/
| seems to be in a pickle:
...
| Does anyone have any idea how I can remove this entry?

I recommend xfs_repair(8)


-- 
Geoffrey Wehrman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
