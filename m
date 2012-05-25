Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PGxipV143195 for <xfs@oss.sgi.com>; Fri, 25 May 2012 11:59:44 -0500
Date: Fri, 25 May 2012 12:59:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: very slow file deletion on an SSD
Message-ID: <20120525165938.GA13555@infradead.org>
References: <4FBF60D1.80104@gmail.com>
 <20120525165719.GV16099@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120525165719.GV16099@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, Joe Landman <joe.landman@gmail.com>

On Fri, May 25, 2012 at 11:57:19AM -0500, Ben Myers wrote:
> There are a couple recent fixes related to discard that are probably
> appropriate for 3.2-stable.

Discard is not enabled by default.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
