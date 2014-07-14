Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC4F07F7C
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 03:26:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A476C304043
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 01:26:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id HvAOMJArwVs6lVW6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 01:26:10 -0700 (PDT)
Date: Mon, 14 Jul 2014 01:26:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: symlink loop for /lib64/libhandle.so
Message-ID: <20140714082607.GA19882@infradead.org>
References: <1404898212.7231.12.camel@jtulak>
	<20140709132836.GA65226@bfoster.bfoster>
	<20140710134851.GA26652@infradead.org>
	<1405009872.31068.22.camel@jtulak> <53BEC1E7.1070904@sandeen.net>
	<1405075678.28203.56.camel@jtulak> <1405325087.3196.6.camel@jtulak>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1405325087.3196.6.camel@jtulak>
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
To: Jan ??ul??k <jan@tulak.me>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, XFS mail list <xfs@oss.sgi.com>

On Mon, Jul 14, 2014 at 10:04:47AM +0200, Jan ??ul??k wrote:
> And I have created a bug report and added the proposed change as a
> patch: http://oss.sgi.com/bugzilla/show_bug.cgi?id=1059

Can you just send the properly formatted and signed off patch to the
list?  That's the usual process for XFS changes and makes everyones life
simpler.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
