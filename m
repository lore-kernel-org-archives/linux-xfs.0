Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92IY3oK073803 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 13:34:03 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id bgFd3uqMofSMYpAT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 11:35:26 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	q92GipXk024750 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 09:44:53 -0700
Message-ID: <506B1A03.7030600@tlinx.org>
Date: Tue, 02 Oct 2012 09:44:51 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Something I've long wished for and wondered why it wasn't
there -- was the ability to edit or re-edit a typed line,
or recall a previous line from history.

I'd really find it useful to even have the ability for it to
save previous command sessions / tool.

Given the usefulness of such, I was wondering why it had
never been done?   Just it never rose to the top of some
task list?  Or was there some desire to keep the tools
less friendly and thus make them more difficult to use for
casual use (i.e. it might have been a conscious design
decision at some point).  Is that reasoning still a strong
enough factor to keep things like that out of the mainline
code?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
