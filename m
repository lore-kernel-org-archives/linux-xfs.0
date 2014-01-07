Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C71277F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 14:51:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E86E304092
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 12:51:34 -0800 (PST)
Date: Tue, 7 Jan 2014 12:51:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/3] xfs: add O_TMPFILE support
Message-ID: <20140107205130.GA5751@infradead.org>
References: <1387326161-24530-1-git-send-email-zwu.kernel@gmail.com>
	<20131226085134.GA32660@infradead.org>
	<20140107204938.GE1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140107204938.GE1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Zhi Yong Wu <zwu.kernel@gmail.com>, xfs@oss.sgi.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-api@vger.kernel.org

On Tue, Jan 07, 2014 at 02:49:38PM -0600, Ben Myers wrote:
> Are you suggesting that we hold off on this until such time as the tests are
> completed?

Yes.  Code that doesn't come with proper test coverage usually tends to
be buggy.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
