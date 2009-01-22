Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MAQdws066929 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 04:26:40 -0600
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEE05A7B18
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 02:25:55 -0800 (PST)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id wor1bLSID7JJ5GsT for
	<xfs@oss.sgi.com>; Thu, 22 Jan 2009 02:25:55 -0800 (PST)
Message-ID: <49784989.1000306@news-service.com>
Date: Thu, 22 Jan 2009 11:25:13 +0100
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: No space left on device on xfs filesystem with 1.6TB free
References: <alpine.LSU.2.00.0901211007200.19898@hermes-2.csi.cam.ac.uk>	<20090121225453.GN10158@disturbed>
	<20090122030955.GT10158@disturbed>
In-Reply-To: <20090122030955.GT10158@disturbed>
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
To: Owen Dunn <osd1000@cam.ac.uk>, xfs@oss.sgi.com

Dave Chinner wrote:
> You've run out of inode space below 1TB or free space is
> sufficiently fragmented below 1TB that new inode chunks cannot
> be allocated.

Is this related to fs growth or can this happen with any xfs partition?

Thanks,

Patrick Schreurs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
