Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 998F07F84
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:16:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 68CDB8F8033
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:16:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 0r89SBnDG2VnEm1X (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:16:28 -0700 (PDT)
Date: Sun, 26 Jul 2015 09:16:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] metadump: Fill attribute values with 'v' rather than
	NUL
Message-ID: <20150726161627.GA29329@infradead.org>
References: <559AC5AA.5040900@sandeen.net>
 <559AC602.5050309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <559AC602.5050309@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
