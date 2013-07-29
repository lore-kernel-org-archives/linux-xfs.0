Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AA0007F3F
	for <linux-xfs@oss.sgi.com>; Sun, 28 Jul 2013 22:42:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A64F8F8033
	for <linux-xfs@oss.sgi.com>; Sun, 28 Jul 2013 20:42:39 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id 6Dbn3iODfvRUj44g (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 20:42:38 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1V3eM0-0000mV-Kw
	for linux-xfs@oss.sgi.com; Mon, 29 Jul 2013 05:42:36 +0200
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 05:42:36 +0200
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 29 Jul 2013 05:42:36 +0200
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
Date: Sun, 28 Jul 2013 20:38:10 -0700
Message-ID: <2m4hcax0nv.ln2@goaway.wombat.san-francisco.ca.us>
References: <20130729000247.GA13468@dastard>
	<32553786.2492.1375056392388.JavaMail.root@benjamin.baylink.com>
	<20130729024105.GC13468@dastard>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

On 2013-07-29, Dave Chinner <david@fromorbit.com> wrote:
>
> The "version" of XFS that you are running is that of the
> kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.

Can't you fairly easily replace a kernel module with a different version
using something like DKMS?  I feel like I did that with xfs a few months
ago.  If accurate, then it's theoretically possible to run a different
version of the xfs kernel module than the running kernel version.  (And
if I'm misremembering then there really is no spoon!)

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
