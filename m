Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E14CF7CA4
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 09:46:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 93F0C8F8049
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 07:46:30 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Ec4Zav0rhsFYMOME (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 May 2016 07:46:28 -0700 (PDT)
Date: Mon, 23 May 2016 07:46:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_quota: only round up timer reporting > 1 day
Message-ID: <20160523144628.GC9319@infradead.org>
References: <2ff612ed-4212-922e-49d2-6d5667288622@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2ff612ed-4212-922e-49d2-6d5667288622@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Zorro Lang <zlang@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
