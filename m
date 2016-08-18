Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBDFD7CA0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 12:38:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B050D8F8037
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:38:35 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id iC6GJ55dcOU9mmgc (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:38:34 -0700 (PDT)
Date: Thu, 18 Aug 2016 10:38:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 xfsprogs 05/14] replace ftruncate64 by equivalent
	ftruncate
Message-ID: <20160818173834.GE27799@infradead.org>
References: <cover.1471107858.git.felix.janda@posteo.de>
	<49056a950fa3548694e074995bd7368c4fc0c54d.1471107858.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49056a950fa3548694e074995bd7368c4fc0c54d.1471107858.git.felix.janda@posteo.de>
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

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
