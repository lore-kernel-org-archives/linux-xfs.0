Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADFEgLD099487 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 09:14:42 -0600
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id JNEnmlC4lnaiv60Q
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Nov 2012 07:16:45 -0800 (PST)
Received: by mail-la0-f53.google.com with SMTP id w12so3220703lag.26
	for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 07:16:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121113023207.GZ9783@sgi.com>
References: <CACnwZYd2kPaK1urLYc8BBuuqD7_Oo1oF+KvqWYj7DAEGy6grHQ@mail.gmail.com>
	<20121113015318.GD25039@dastard>
	<CACnwZYeutkdb+=yYx8XcXHSDhaP6QBjgn1BEnGAMYDO7biAtFw@mail.gmail.com>
	<20121113023207.GZ9783@sgi.com>
Date: Tue, 13 Nov 2012 13:16:43 -0200
Message-ID: <CACnwZYfVXmy74Fpn0eqa63Zgc89fP9BPoRxXf-=_MhENddjnSw@mail.gmail.com>
Subject: Re: xfs: Remove boolean_t typedef completely.
From: Thiago Farina <tfransosi@gmail.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

On Tue, Nov 13, 2012 at 12:32 AM, Ben Myers <bpm@sgi.com> wrote:
>> >> > Also, can you please place patches in line rather than attaching
>> >> > them. Attaching them means they cannot be quoted in reply. See
>> >> > Documentation/SubmittingPatches and Documentation/email-clients.txt
>> >> > for guidelines.
None of these docs say anything about send-email.

>> > It's still attached as a base64 encoded attachment, not as inline
>> > text....
>> >
>> Yep, sorry about that. Is just a text file from $(git format-patch master);
>
> If you don't mind another try...
No, thanks. It's too painful to use git send-email, the patch is
attached, if you want to take it, then fine, if not then it's fine too
:)

> it would be helpful if you could resend the
> patch inline.  It helps to facilitate a discussion of the patch along with your
> text should it be necessary.
>
> You're only touching xfs, so you can drop linux-kernel if you want.
>
Dropped linux-kernel

Thanks,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
