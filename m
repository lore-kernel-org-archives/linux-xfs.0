Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E576A7FAA
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 07:30:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C48068F806F
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 05:30:17 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id X38I2BERHBSJwuY9 for
	<xfs@oss.sgi.com>; Tue, 09 Apr 2013 05:30:14 -0700 (PDT)
Date: Tue, 9 Apr 2013 14:30:10 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_repair has been running for a very long time, no disk IO.
Message-ID: <20130409143010.114f3fda@harpe.intellique.com>
In-Reply-To: <20130409120236.GL17758@dastard>
References: <20130409121726.6342519e@harpe.intellique.com>
	<20130409120236.GL17758@dastard>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Le Tue, 9 Apr 2013 22:02:36 +1000
Dave Chinner <david@fromorbit.com> =E9crivait:

> Either use the latest version, or use the -P option.
> =


Currently running the latest version (3.1.11-pre2). I'll wait for a
while (it takes something like 10 minutes to reach the point at which it
freezes over). I suppose -P makes it slower?

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
