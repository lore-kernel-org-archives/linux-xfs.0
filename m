Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92IeXac074943 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 13:40:33 -0500
Received: from p01c12o147.mxlogic.net (p01c12o147.mxlogic.net [208.65.145.70])
	by cuda.sgi.com with ESMTP id dEp3GPxgIdjT22Hb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 11:41:56 -0700 (PDT)
From: "Kinzel, David" <David.Kinzel@encana.com>
Subject: RE: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
Date: Tue, 2 Oct 2012 18:41:30 +0000
Message-ID: <A233B8D667A4114D983511EE6E8C438948CE43A6@CGYEX1041>
References: <506B1A03.7030600@tlinx.org>
In-Reply-To: <506B1A03.7030600@tlinx.org>
Content-Language: en-US
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: 'xfs-oss' <xfs@oss.sgi.com>

>From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf Of
>Linda Walsh
>Something I've long wished for and wondered why it wasn't
>there -- was the ability to edit or re-edit a typed line,
>or recall a previous line from history.
>
>I'd really find it useful to even have the ability for it to
>save previous command sessions / tool.
>

You can use the utility rlwrap to mimic this behaviour if you need it that bad.

>Given the usefulness of such, I was wondering why it had
>never been done?   Just it never rose to the top of some
>task list?  Or was there some desire to keep the tools
>less friendly and thus make them more difficult to use for
>casual use (i.e. it might have been a conscious design
>decision at some point).  Is that reasoning still a strong
>enough factor to keep things like that out of the mainline
>code?
>



This email communication and any files transmitted with it may contain
confidential and or proprietary information and is provided for the use of the
intended recipient only. Any review, retransmission or dissemination of this
information by anyone other than the intended recipient is prohibited. If you
receive this email in error, please contact the sender and delete this
communication and any copies immediately. Thank you.

http://www.encana.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
