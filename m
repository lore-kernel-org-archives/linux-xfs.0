Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 16CCA29E10
	for <linux-xfs@oss.sgi.com>; Fri, 26 Jul 2013 23:28:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94483AC002
	for <linux-xfs@oss.sgi.com>; Fri, 26 Jul 2013 21:28:40 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id yCZI0CFp1YKdgghf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 21:28:38 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1V2w7R-0001sX-AK
	for linux-xfs@oss.sgi.com; Sat, 27 Jul 2013 06:28:37 +0200
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 27 Jul 2013 06:28:37 +0200
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 27 Jul 2013 06:28:37 +0200
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: understanding speculative preallocation
Date: Fri, 26 Jul 2013 21:26:11 -0700
Message-ID: <3oubcax643.ln2@goaway.wombat.san-francisco.ca.us>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
	<51F2CD8B.8080207@hardwarefreak.com>
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

On 2013-07-26, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Either pay for and receive the support that's required for the
> proprietary distribution you're running, or use a completely open source
> distro based on mainline kernel source and GNU user space.

Couldn't you simply run a mainline kernel on CentOS?  elrepo supports
both the mainline kernel and the longterm kernel.

http://elrepo.org/tiki/kernel-ml
http://elrepo.org/tiki/kernel-lt

It's not perfect, of course, but at least it's closer to what the XFS
developers (RH employees and others) are working on.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
