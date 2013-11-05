Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E7E9E7FA6
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 04:34:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BBF69304053
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 02:34:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id D5pwkiBc9M2gVAec (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 02:34:39 -0800 (PST)
Date: Tue, 5 Nov 2013 02:34:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20131105103435.GA24387@infradead.org>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
	<20120613013549.GO22848@dastard> <20120613033052.GT22848@dastard>
	<4FD82F89.80106@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD82F89.80106@redhat.com>
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
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Wed, Jun 13, 2012 at 08:13:29AM +0200, Paolo Bonzini wrote:
> Sure.  Thanks for the hints, I'll submit a v2 (may take a while as I'll
> leave for holiday soon).

Did you ever get back to this?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
