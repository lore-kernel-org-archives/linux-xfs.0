Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5B4507F3F
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 09:10:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4758D304066
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 07:10:45 -0800 (PST)
Received: from mail-ve0-f178.google.com (mail-ve0-f178.google.com
	[209.85.128.178]) by cuda.sgi.com with ESMTP id
	FtDTgUBDxxxsFhXW (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 07:10:44 -0800 (PST)
Received: by mail-ve0-f178.google.com with SMTP id db10so673595veb.9
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 07:10:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130227150715.GA4492@redhat.com>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard> <20130227150715.GA4492@redhat.com>
Date: Wed, 27 Feb 2013 10:10:43 -0500
Message-ID: <CAMGZZZ0W_jkT22r3bU1yhRi1Z0nOefEECfWB6otGwydQr9hpRw@mail.gmail.com>
Subject: Re: pvmove corrupting XFS filesystems (was Re: [BUG] Internal error
	xfs_dir2_data_reada_verify)
From: Matteo Frigo <athena@fftw.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9082203358241973025=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com

--===============9082203358241973025==
Content-Type: multipart/alternative; boundary=20cf307d07449359dd04d6b62d95

--20cf307d07449359dd04d6b62d95
Content-Type: text/plain; charset=ISO-8859-1

I have "issue_discards = 0" in lvm.conf, so this not appear to be the
problem.

--20cf307d07449359dd04d6b62d95
Content-Type: text/html; charset=ISO-8859-1

<div dir="ltr">I have &quot;issue_discards = 0&quot; in lvm.conf, so this not appear to be the problem.<br><br></div>

--20cf307d07449359dd04d6b62d95--


--===============9082203358241973025==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9082203358241973025==--
