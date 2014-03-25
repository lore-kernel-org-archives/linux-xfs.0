Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AFBD029DF7
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 08:17:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29A18AC003
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 06:17:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id pFqdWVsZgoBKeOFE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Mar 2014 06:17:40 -0700 (PDT)
Date: Tue, 25 Mar 2014 06:17:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] remove ancient sys_getdents code paths
Message-ID: <20140325131740.GC25392@infradead.org>
References: <20140324181920.GG23291@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140324181920.GG23291@redacted.bos.redhat.com>
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
To: Kyle McMartin <kmcmarti@redhat.com>
Cc: xfs@oss.sgi.com

Both patches look good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

I'd merge the two into one if it was up to me, but I'm also fine with
commiting them as-is.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
