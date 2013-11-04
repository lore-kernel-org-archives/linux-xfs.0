Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D60457F77
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 14:43:08 -0600 (CST)
Message-ID: <527806E1.3090704@sgi.com>
Date: Mon, 4 Nov 2013 14:43:13 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: generic/317 use relative paths to avoid
	traversal permission problems
References: <20131024161235.GA29381@infradead.org>	<20131024162557.6dd72435@oracle.com>	<20131025093333.GB24583@infradead.org>	<20131028114328.4b05e0ee@oracle.com>	<20131030161955.GA28755@infradead.org>	<20131030162441.GA1112@infradead.org>
	<20131030143050.34a3b120@oracle.com>
In-Reply-To: <20131030143050.34a3b120@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

This has been committed.

Thanks
--Rich

commit 4818302fbf5c4c64dbe2fb3e504e71ceafff50e3
Author: Dwight Engen <dwight.engen@oracle.com>
Date:   Wed Oct 30 18:30:50 2013 +0000

     xfstests: generic/317 use relative paths to avoid traversal 
permission problems

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
