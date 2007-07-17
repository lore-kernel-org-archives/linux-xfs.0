Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 17:59:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6H0xmbm006698
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 17:59:50 -0700
Subject: TAKE 965309 - xfs-cmds man pages don't conform to linux formatting standards
Message-Id: <20070717005947.848AD58C52B2@chook.melbourne.sgi.com>
Date: Tue, 17 Jul 2007 10:59:47 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Update man pages to linux formatting/macro standards


Date:  Tue Jul 17 10:59:25 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  markgw@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29156a
xfsprogs/man/man3/handle.3 - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man3/handle.3.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/man/man5/xfs.5 - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man5/xfs.5.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/man/man8/xfs_growfs.8 - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_growfs.8.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfsprogs/man/man8/xfs_admin.8 - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_admin.8.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfsprogs/man/man8/xfs_ncheck.8 - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_ncheck.8.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
xfsprogs/man/man8/xfs_logprint.8 - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_logprint.8.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
xfsprogs/man/man8/xfs_db.8 - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_db.8.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/man/man8/mkfs.xfs.8 - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/mkfs.xfs.8.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
xfsprogs/man/man8/xfs_check.8 - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_check.8.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
xfsprogs/man/man8/xfs_mkfile.8 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_mkfile.8.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfsprogs/man/man8/xfs_rtcp.8 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_rtcp.8.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfsprogs/man/man8/fsck.xfs.8 - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/fsck.xfs.8.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
xfsprogs/man/man8/xfs_freeze.8 - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_freeze.8.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfsprogs/man/man8/xfs_io.8 - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_io.8.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/man/man8/xfs_copy.8 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_copy.8.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfsprogs/man/man8/xfs_quota.8 - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_quota.8.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/man/man8/xfs_mdrestore.8 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_mdrestore.8.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfsprogs/man/man8/xfs_metadump.8 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_metadump.8.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Update man pages to linux formatting/macro standards
