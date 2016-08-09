Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3F0677CA3
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 02:39:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A7C56AC003
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 00:39:21 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 62G6sdStKXwHWrb4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 00:39:19 -0700 (PDT)
Date: Tue, 9 Aug 2016 00:39:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfsprogs 10/14] replace sendfile64 by equivalent sendfile
Message-ID: <20160809073918.GL25647@infradead.org>
References: <cover.1470555003.git.felix.janda@posteo.de>
	<381255cfec13dc45dd4fe2232e94dc6ead92952b.1470555003.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <381255cfec13dc45dd4fe2232e94dc6ead92952b.1470555003.git.felix.janda@posteo.de>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
