Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E76A7CA4
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 06:51:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43C4E304048
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 04:51:40 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 3YAt0WiMqeIsRWbr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 04:51:39 -0700 (PDT)
Date: Thu, 12 May 2016 04:51:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_quota: check report_mount return value
Message-ID: <20160512115138.GB32528@infradead.org>
References: <1e8b9ace-2fa3-bc11-4487-19be60053ef9@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1e8b9ace-2fa3-bc11-4487-19be60053ef9@sandeen.net>
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
Cc: Zorro Lang <zlang@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
