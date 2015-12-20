Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A75D7F62
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 09:37:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3955E8F8037
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 07:37:24 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id tZ0GM5gPirR8lKob (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 20 Dec 2015 07:37:22 -0800 (PST)
Date: Sun, 20 Dec 2015 07:37:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/4] xfsprogs: xfsdb: remove unnessary checks in
	process_leaf_node_dir_v2_free
Message-ID: <20151220153721.GF20135@infradead.org>
References: <1449832143-26356-1-git-send-email-t.vivek@samsung.com>
	<1449832143-26356-5-git-send-email-t.vivek@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1449832143-26356-5-git-send-email-t.vivek@samsung.com>
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
To: Vivek Trivedi <t.vivek@samsung.com>
Cc: a.sahrawat@samsung.com, pankaj.m@samsung.com, xfs@oss.sgi.com

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
