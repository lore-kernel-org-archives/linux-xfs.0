Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A1E47F89
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 07:48:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C714AC005
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 05:48:50 -0800 (PST)
Date: Thu, 7 Nov 2013 05:48:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstest failures
Message-ID: <20131107134848.GA1163@infradead.org>
References: <20131106105451.GA31283@infradead.org>
	<20131106161825.GU1935@sgi.com> <527A887F.2030807@sandeen.net>
	<20131107081710.GC25157@infradead.org>
	<527B948C.9060905@sandeen.net>
	<20131107132739.GA16608@infradead.org>
	<527B99C3.6090903@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <527B99C3.6090903@sandeen.net>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 07:46:43AM -0600, Eric Sandeen wrote:
> Would an expected failure be only for tests which are known to be
> not-fixed anywhere?


Exactly.  If you want to be fancy we could allow a drop-in file to
override it if you want something for RHEL testing or similar

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
