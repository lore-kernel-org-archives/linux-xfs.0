Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0ACF17F37
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 15:31:15 -0500 (CDT)
Date: Thu, 18 Sep 2014 15:31:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 00/13] xfsprogs: Unicode/UTF-8 support for XFS
Message-ID: <20140918203114.GN4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918195650.GI19952@sgi.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

Hi,

Here is the xfsprogs portion of the Unicode/UTF-8 support.  A number of
the patches in libxfs correspond with kernel patches previously posted,
and then there are patches to add support to mkfs, xfs_info, xfs_repair,
and a test.

(Note that the Unicode character database files have also been removed
here due to their size.)

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
