Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 723857CB4
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 09:33:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4411830404E
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 07:33:16 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gX1CUp7NER5dBS0y (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 25 Sep 2016 07:33:14 -0700 (PDT)
Date: Sun, 25 Sep 2016 07:33:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH]remove rcu_lock/unlock around lockless radix_tree_tagged()
Message-ID: <20160925143312.GC29268@infradead.org>
References: <CADccLx9oHDQLDifPAu+tB7pD6OmHu6Mgt7qtMSNtqrgPRNCVGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADccLx9oHDQLDifPAu+tB7pD6OmHu6Mgt7qtMSNtqrgPRNCVGQ@mail.gmail.com>
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
To: sudip midya <midya.sudip@gmail.com>
Cc: xfs@oss.sgi.com

Hi sudip,

the patch looks fine, but the format of the email is odd.  Can you
resend it after (re-)reading Documentation/SubmittingPatches and
ajusting?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
