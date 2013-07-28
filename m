Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 50DD27F76
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 00:09:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 30C0A8F8035
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 22:09:17 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id c6PI6QK8JrCVX9MT
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 22:09:16 -0700 (PDT)
Message-ID: <51F4A77A.30502@hardwarefreak.com>
Date: Sun, 28 Jul 2013 00:09:14 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Purpose of the XFS list -- was: A short digression on FOSS (Re:
	understanding speculative preallocation)
References: <31450470.2412.1374978094689.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <31450470.2412.1374978094689.JavaMail.root@benjamin.baylink.com>
Reply-To: stan@hardwarefreak.com
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
To: Jay Ashworth <jra@baylink.com>
Cc: xfs@oss.sgi.com

On 7/27/2013 9:21 PM, Jay Ashworth wrote:
...
> From there, we veered *very* close to "we don't talk to people unless 
> they're paying Red Had customers"...

Not even close.  We don't typically talk to RHEL customers on this
mailing list Jay.  RHEL customers get their XFS support via Red Hat
Customer Support.  Let's cut through all the BS, educate you, and end
this OT thread.  Pay attention.

The XFS mailing list exists for _mainline Linux_ XFS development,
discussion, collaboration, and user support.  The list is hosted by SGI,
as well as the primary list archive, the master branch repo, etc.  Red
Hat now employs, has for some years, most/all of the core XFS
developers, many of whom previously worked for SGI.  Their participation
on the XFS list is the same as the purpose of the XFS list itself, as
stated above.  The work they do for the RHEL kernel isn't discussed here
and the RHEL kernel isn't generally supported here because it is not a
mainline kernel, and because those users should be assisted by Red Hat
Support--after all they pay for that.

CentOS is a direct clone of RHEL.  It uses the RHEL kernel.  Thus XFS in
the CentOS kernel is not generally supported on this mailing list.
CentOS (and RHEL) userland XFS tools yes, kernel no.  If there were some
other custom distro kernel out there that was non mainline, it wouldn't
get support here either.

The reason "we" (and I'm not a Red Hat employee, nor a RHEL user)
suggest to CentOS users that they become paying RHEL customers is
obvious:  they already use the software and are familiar and presumably
comfortable with it and prefer it.  If they pay they get Red Hat support
for XFS in the kernel, along with anything else kernel related.  If they
want to continue to use a "no cost" OS and get support on this mailing
list, they must have a distro with a mainline kernel.  So the other
obvious option is move to a distro that uses a mainline kernel.  They
may also be able to install a mainline kernel on CentOS, as someone
suggested previously.

Nobody here is aiming guns at CentOS users heads.  They have plenty of
support options.  It just so happens that using the stock CentOS (RHEL)
kernel isn't one of them.

-- 
Stan



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
