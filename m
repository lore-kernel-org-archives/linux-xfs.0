Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Dec 2006 05:54:49 -0800 (PST)
Received: from web32704.mail.mud.yahoo.com (web32704.mail.mud.yahoo.com [68.142.207.248])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBFDseqw015233
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 05:54:41 -0800
Date: Fri, 15 Dec 2006 04:53:49 -0800 (PST)
From: chandrasekar mahalingam <sekar1175@yahoo.com>
Subject: not able to create XFS filesystem
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <743683.94860.qm@web32704.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi
   my RHEL 4 machine (Linux spea44 2.6.9-42.ELsmp #1
SMP Wed Jul 12 23:32:02 EDT 2006 x86_64 x86_64 x86_64
GNU/Linux) has the rpm installed for XFS . 

xorg-x11-xfs-6.8.2-1.EL.13.36 and
xorg-x11-libs-6.8.2-1.EL.13.36

when i try to create a file system using
 "mkfs -t xfs /dev/sekarvg/simple1" it says "mkfs.XFS:
No such file or directory" . "lsmod|grep -i xfs " does
not list xfs . 

Please let me know as what needs to be done to proceed
further.

Thanks & Regards
M.Chandrasekar.


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
