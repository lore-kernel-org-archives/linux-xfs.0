Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C155F29DF7
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 09:07:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C42E304043
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 07:06:57 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8dgkBKEcDndui6nu for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 07:06:53 -0800 (PST)
Message-ID: <530F548C.9060302@sandeen.net>
Date: Thu, 27 Feb 2014 09:06:52 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS on Fedora i686, armv7hl
References: <8A28EF88-012E-4036-BDB6-E76B1CC569A7@colorremedies.com>
In-Reply-To: <8A28EF88-012E-4036-BDB6-E76B1CC569A7@colorremedies.com>
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
To: Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 2/26/14, 11:37 PM, Chris Murphy wrote:
> Hi,
> 
> Fedora is considering XFS as their default file system. They support
> three primary architectures: x86_64, i686, and armv7hl.  Do XFS devs
> have any reservations about XFS as a default file system on either
> i686, or arm?

As Dave said, we rely on others to do ARM testing for the most part,
though I've certainly jumped in and debugged some issues from time
to time.

It'd be super if Fedora could run the xfstests test suite on arm
as part of QE.  I'd be more than happy to help get that started
if people are interested.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
