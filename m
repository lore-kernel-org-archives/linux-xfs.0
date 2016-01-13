Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 06D727F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 01:59:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB3368F8040
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:59:39 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4YGLnm0R6HNLENTI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:59:39 -0800 (PST)
Date: Tue, 12 Jan 2016 23:59:38 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] dump/content.c: Include <linux/limits.h> for
	XATTR_LIST_MAX
Message-ID: <20160113075938.GI21939@infradead.org>
References: <cover.1452632647.git.felix.janda@posteo.de>
	<20160112210820.GC10044@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112210820.GC10044@nyan>
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
