Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9P3gn5k077443 for <xfs@oss.sgi.com>; Sat, 24 Oct 2009 22:42:49 -0500
Date: Sat, 24 Oct 2009 23:44:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2]  add lpath_to_handle to libhandle
Message-ID: <20091025034424.GA13129@infradead.org>
References: <4AE08DC7.7000200@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AE08DC7.7000200@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

This also needs documentation in the path_to_handle manpage, including
a good way to find the fspath argumeent if you stick with that, and
the failure mode if it points to a wrong filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
